import { describe, expect, it } from "vitest";
import { resolveIrcInboundTarget } from "./monitor.js";

describe("irc monitor inbound target", () => {
  it("keeps channel target for group messages", () => {
    expect(
      resolveIrcInboundTarget({
        target: "#clawx",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: true,
      target: "#clawx",
      rawTarget: "#clawx",
    });
  });

  it("maps DM target to sender nick and preserves raw target", () => {
    expect(
      resolveIrcInboundTarget({
        target: "clawx-bot",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: false,
      target: "alice",
      rawTarget: "clawx-bot",
    });
  });

  it("falls back to raw target when sender nick is empty", () => {
    expect(
      resolveIrcInboundTarget({
        target: "clawx-bot",
        senderNick: " ",
      }),
    ).toEqual({
      isGroup: false,
      target: "clawx-bot",
      rawTarget: "clawx-bot",
    });
  });
});
