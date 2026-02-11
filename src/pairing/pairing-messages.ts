import type { PairingChannel } from "./pairing-store.js";
import { formatCliCommand } from "../cli/command-format.js";

export function buildPairingReply(params: {
  channel: PairingChannel;
  idLine: string;
  code: string;
}): string {
  const { channel, idLine, code } = params;
  return [
    "ClawX: access not configured.",
    "",
    idLine,
    "",
    `Pairing code: ${code}`,
    "",
    "Ask the bot owner to approve with:",
    formatCliCommand(`clawx pairing approve ${channel} <code>`),
  ].join("\n");
}
