// 新しく起動した iOS Simulator のデバイスの音量を 0 にする menu-bar コマンド。
// package.json の interval で 10 秒ごとにバックグラウンド実行され、アイコンで状態を示す。
//
// simctl には音量を操作するコマンドが無いので、Simulator.app の
// I/O > Decrease Volume を System Events でクリックする。
// iOS の音量は 16 段階なので 16 回押せば必ず 0 になる。
// osascript は Raycast の子プロセスとして動くので、Raycast のアクセシビリティ権限で動く。

import { Clipboard, Color, Icon, LocalStorage, MenuBarExtra, open } from "@raycast/api";
import { execFile } from "node:child_process";
import { useEffect, useState } from "react";

type State = {
  enabled: boolean;
  lastCheckAt?: string;
  lastMuted?: { name: string; at: string };
  lastError?: { message: string; at: string };
};

type Device = { udid: string; name: string; lastBootedAt?: string };

// 起動直後は SpringBoard が上がっていても音量操作が効かないことがあるので、少し待ってから押す
const BOOT_GRACE_MS = 30_000;

// ミュート済みの記録は起動 1 回単位。手で上げた音量は次の起動で 0 に戻し、起動中は触らない
const bootKey = (device: Device) => `${device.udid}@${device.lastBootedAt ?? ""}`;

const KEY_ENABLED = "enabled";
const KEY_MUTED = "muted";
const KEY_STATE = "state";

const MUTE_SCRIPT = `
on run argv
  set deviceName to item 1 of argv
  tell application "System Events"
    -- 作業中のウィンドウからフォーカスを奪わないよう、Simulator は前面に出さずに操作する
    set frontAppId to bundle identifier of first application process whose frontmost is true
    tell process "Simulator"
      set targetWindows to (windows whose name contains deviceName)
      if (count of targetWindows) is 0 then return "nowindow"
      set targetWindow to item 1 of targetWindows
      -- I/O メニューは Simulator のメインウィンドウのデバイスに効く。
      -- 複数台起動していると AXMain だけでは切り替わらないことがあるので、ウィンドウを
      -- 最前面に上げ (アプリ自体は前面に出ない)、切り替わったのを確かめてから押す
      perform action "AXRaise" of targetWindow
      set value of attribute "AXMain" of targetWindow to true
      delay 0.2
      if value of attribute "AXMain" of targetWindow is not true then return "notmain"
      repeat 16 times
        click menu item "Decrease Volume" of menu "I/O" of menu bar 1
        delay 0.05
      end repeat
    end tell
  end tell
  -- 念のため、操作中にフォーカスが動いていたら元のアプリに戻す
  tell application "System Events" to set nowFrontId to bundle identifier of first application process whose frontmost is true
  if nowFrontId is not frontAppId then tell application id frontAppId to activate
  return "ok"
end run
`;

function run(file: string, args: string[], timeout = 15_000): Promise<string> {
  return new Promise((resolve, reject) => {
    execFile(file, args, { timeout }, (error, stdout, stderr) => {
      if (error) reject(new Error((stderr || error.message).trim()));
      else resolve(stdout.trim());
    });
  });
}

async function isSimulatorRunning(): Promise<boolean> {
  try {
    await run("/usr/bin/pgrep", ["-xq", "Simulator"]);
    return true;
  } catch {
    return false;
  }
}

// simctl の JSON に lastBootedAt が無いときは、デバイスの device.plist から読む
async function lastBootedAt(device: Device & { dataPath?: string }): Promise<string | undefined> {
  if (device.lastBootedAt) return device.lastBootedAt;
  if (!device.dataPath) return undefined;
  const plist = device.dataPath.replace(/\/data\/?$/, "/device.plist");
  return run("/usr/bin/plutil", ["-extract", "lastBootedAt", "raw", plist]).catch(() => undefined);
}

async function bootedDevices(): Promise<Device[]> {
  const json = JSON.parse(await run("/usr/bin/xcrun", ["simctl", "list", "devices", "booted", "-j"]));
  const devices = Object.values(json.devices as Record<string, (Device & { dataPath?: string })[]>).flat();
  return Promise.all(
    devices.map(async (device) => ({ udid: device.udid, name: device.name, lastBootedAt: await lastBootedAt(device) })),
  );
}

// 大半の時間は Simulator が起動していないので、pgrep だけで終わる
async function tick(state: State): Promise<State> {
  const next: State = { ...state, lastCheckAt: new Date().toISOString() };
  if (!state.enabled || !(await isSimulatorRunning())) return next;

  const devices = await bootedDevices();
  // 一度 0 にした起動では二度と押さない。音量を変えるたびにホストのオーディオ出力が乱れ、
  // 再生中の音にノイズが乗るため。起動中に手で上げた音量もそのまま残す
  const saved: string[] = JSON.parse((await LocalStorage.getItem<string>(KEY_MUTED)) ?? "[]");
  // 今起動していない起動の記録は二度と一致しないので捨てる
  const muted = saved.filter((key) => devices.some((device) => bootKey(device) === key));

  for (const device of devices) {
    if (muted.includes(bootKey(device))) continue;
    const bootedAt = device.lastBootedAt ? Date.parse(device.lastBootedAt) : NaN;
    if (Date.now() - bootedAt < BOOT_GRACE_MS) continue;
    try {
      // SpringBoard が上がる前に押しても効かない。待ちきれなければ次回に再試行する
      await run("/usr/bin/xcrun", ["simctl", "bootstatus", device.udid], 5_000);
      const result = await run("/usr/bin/osascript", ["-e", MUTE_SCRIPT, device.name]);
      // headless boot、ウィンドウがまだ出ていない、または別のデバイスのウィンドウがメインのまま。
      // 次回に再試行する
      if (result === "nowindow" || result === "notmain") continue;
      muted.push(bootKey(device));
      next.lastMuted = { name: device.name, at: new Date().toISOString() };
      next.lastError = undefined;
    } catch (error) {
      if ((error as Error).message.includes("timed out")) continue;
      next.lastError = { message: `${device.name}: ${(error as Error).message}`, at: new Date().toISOString() };
    }
  }

  await LocalStorage.setItem(KEY_MUTED, JSON.stringify(muted));
  return next;
}

async function loadState(): Promise<State> {
  const saved: Partial<State> = JSON.parse((await LocalStorage.getItem<string>(KEY_STATE)) ?? "{}");
  return { ...saved, enabled: (await LocalStorage.getItem<string>(KEY_ENABLED)) !== "false" };
}

function time(iso?: string): string {
  return iso ? new Date(iso).toLocaleTimeString("ja-JP") : "-";
}

async function check(): Promise<State> {
  let next = await loadState();
  try {
    next = await tick(next);
  } catch (error) {
    next = { ...next, lastError: { message: (error as Error).message, at: new Date().toISOString() } };
  }
  const { enabled: _, ...persisted } = next;
  await LocalStorage.setItem(KEY_STATE, JSON.stringify(persisted));
  return next;
}

export default function Command() {
  const [state, setState] = useState<State>();

  useEffect(() => {
    check().then(setState);
  }, []);

  const toggle = async () => {
    if (!state) return;
    const enabled = !state.enabled;
    await LocalStorage.setItem(KEY_ENABLED, String(enabled));
    setState({ ...state, enabled });
  };

  const status = !state ? "確認中" : !state.enabled ? "停止中" : state.lastError ? "ミュート失敗あり" : "動作中";
  const tintColor = !state?.enabled ? Color.SecondaryText : state.lastError ? Color.Orange : undefined;

  return (
    <MenuBarExtra icon={{ source: Icon.Mobile, tintColor }} tooltip={`Simulator Mute: ${status}`} isLoading={!state}>
      <MenuBarExtra.Section title={`Simulator Mute: ${status}`}>
        <MenuBarExtra.Item icon={Icon.Clock} title="最終チェック" subtitle={time(state?.lastCheckAt)} />
        {state?.lastMuted && (
          <MenuBarExtra.Item
            icon={{ source: Icon.SpeakerOff, tintColor: Color.Green }}
            title={`最終ミュート: ${state.lastMuted.name}`}
            subtitle={time(state.lastMuted.at)}
          />
        )}
        {state?.lastError && (
          // 項目の文字色は変えられないので、アイコンの色で目立たせる。全文は tooltip、クリックでコピー
          <MenuBarExtra.Item
            icon={{ source: Icon.Warning, tintColor: Color.Orange }}
            title={`失敗: ${state.lastError.message.slice(0, 80)}`}
            subtitle={time(state.lastError.at)}
            tooltip={state.lastError.message}
            onAction={() => Clipboard.copy(state.lastError?.message ?? "")}
          />
        )}
      </MenuBarExtra.Section>
      <MenuBarExtra.Section>
        <MenuBarExtra.Item icon={Icon.ArrowClockwise} title="今すぐ実行" onAction={() => check().then(setState)} />
        <MenuBarExtra.Item
          icon={Icon.Trash}
          title="ミュート記録をリセット"
          tooltip="起動中のデバイスをもう一度 0 にしたいときに使う (次の起動では記録が無くても 0 にする)"
          onAction={() => LocalStorage.removeItem(KEY_MUTED).then(check).then(setState)}
        />
        <MenuBarExtra.Item
          icon={state?.enabled ? Icon.Pause : Icon.Play}
          title={state?.enabled ? "停止" : "開始"}
          onAction={toggle}
        />
        <MenuBarExtra.Item
          icon={Icon.Gear}
          title="アクセシビリティ設定を開く"
          onAction={() => open("x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")}
        />
      </MenuBarExtra.Section>
    </MenuBarExtra>
  );
}
