import { describe, expect, it } from "vitest";
import {
  buildParseArgv,
  getFlagValue,
  getCommandPath,
  getPrimaryCommand,
  getPositiveIntFlagValue,
  getVerboseFlag,
  hasHelpOrVersion,
  hasFlag,
  shouldMigrateState,
  shouldMigrateStateFromPath,
} from "./argv.js";

describe("argv helpers", () => {
  it("detects help/version flags", () => {
    expect(hasHelpOrVersion(["node", "clawx", "--help"])).toBe(true);
    expect(hasHelpOrVersion(["node", "clawx", "-V"])).toBe(true);
    expect(hasHelpOrVersion(["node", "clawx", "status"])).toBe(false);
  });

  it("extracts command path ignoring flags and terminator", () => {
    expect(getCommandPath(["node", "clawx", "status", "--json"], 2)).toEqual(["status"]);
    expect(getCommandPath(["node", "clawx", "agents", "list"], 2)).toEqual(["agents", "list"]);
    expect(getCommandPath(["node", "clawx", "status", "--", "ignored"], 2)).toEqual(["status"]);
  });

  it("returns primary command", () => {
    expect(getPrimaryCommand(["node", "clawx", "agents", "list"])).toBe("agents");
    expect(getPrimaryCommand(["node", "clawx"])).toBeNull();
  });

  it("parses boolean flags and ignores terminator", () => {
    expect(hasFlag(["node", "clawx", "status", "--json"], "--json")).toBe(true);
    expect(hasFlag(["node", "clawx", "--", "--json"], "--json")).toBe(false);
  });

  it("extracts flag values with equals and missing values", () => {
    expect(getFlagValue(["node", "clawx", "status", "--timeout", "5000"], "--timeout")).toBe(
      "5000",
    );
    expect(getFlagValue(["node", "clawx", "status", "--timeout=2500"], "--timeout")).toBe("2500");
    expect(getFlagValue(["node", "clawx", "status", "--timeout"], "--timeout")).toBeNull();
    expect(getFlagValue(["node", "clawx", "status", "--timeout", "--json"], "--timeout")).toBe(
      null,
    );
    expect(getFlagValue(["node", "clawx", "--", "--timeout=99"], "--timeout")).toBeUndefined();
  });

  it("parses verbose flags", () => {
    expect(getVerboseFlag(["node", "clawx", "status", "--verbose"])).toBe(true);
    expect(getVerboseFlag(["node", "clawx", "status", "--debug"])).toBe(false);
    expect(getVerboseFlag(["node", "clawx", "status", "--debug"], { includeDebug: true })).toBe(
      true,
    );
  });

  it("parses positive integer flag values", () => {
    expect(getPositiveIntFlagValue(["node", "clawx", "status"], "--timeout")).toBeUndefined();
    expect(
      getPositiveIntFlagValue(["node", "clawx", "status", "--timeout"], "--timeout"),
    ).toBeNull();
    expect(
      getPositiveIntFlagValue(["node", "clawx", "status", "--timeout", "5000"], "--timeout"),
    ).toBe(5000);
    expect(
      getPositiveIntFlagValue(["node", "clawx", "status", "--timeout", "nope"], "--timeout"),
    ).toBeUndefined();
  });

  it("builds parse argv from raw args", () => {
    const nodeArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["node", "clawx", "status"],
    });
    expect(nodeArgv).toEqual(["node", "clawx", "status"]);

    const versionedNodeArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["node-22", "clawx", "status"],
    });
    expect(versionedNodeArgv).toEqual(["node-22", "clawx", "status"]);

    const versionedNodeWindowsArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["node-22.2.0.exe", "clawx", "status"],
    });
    expect(versionedNodeWindowsArgv).toEqual(["node-22.2.0.exe", "clawx", "status"]);

    const versionedNodePatchlessArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["node-22.2", "clawx", "status"],
    });
    expect(versionedNodePatchlessArgv).toEqual(["node-22.2", "clawx", "status"]);

    const versionedNodeWindowsPatchlessArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["node-22.2.exe", "clawx", "status"],
    });
    expect(versionedNodeWindowsPatchlessArgv).toEqual(["node-22.2.exe", "clawx", "status"]);

    const versionedNodeWithPathArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["/usr/bin/node-22.2.0", "clawx", "status"],
    });
    expect(versionedNodeWithPathArgv).toEqual(["/usr/bin/node-22.2.0", "clawx", "status"]);

    const nodejsArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["nodejs", "clawx", "status"],
    });
    expect(nodejsArgv).toEqual(["nodejs", "clawx", "status"]);

    const nonVersionedNodeArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["node-dev", "clawx", "status"],
    });
    expect(nonVersionedNodeArgv).toEqual(["node", "clawx", "node-dev", "clawx", "status"]);

    const directArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["clawx", "status"],
    });
    expect(directArgv).toEqual(["node", "clawx", "status"]);

    const bunArgv = buildParseArgv({
      programName: "clawx",
      rawArgs: ["bun", "src/entry.ts", "status"],
    });
    expect(bunArgv).toEqual(["bun", "src/entry.ts", "status"]);
  });

  it("builds parse argv from fallback args", () => {
    const fallbackArgv = buildParseArgv({
      programName: "clawx",
      fallbackArgv: ["status"],
    });
    expect(fallbackArgv).toEqual(["node", "clawx", "status"]);
  });

  it("decides when to migrate state", () => {
    expect(shouldMigrateState(["node", "clawx", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "clawx", "health"])).toBe(false);
    expect(shouldMigrateState(["node", "clawx", "sessions"])).toBe(false);
    expect(shouldMigrateState(["node", "clawx", "memory", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "clawx", "agent", "--message", "hi"])).toBe(false);
    expect(shouldMigrateState(["node", "clawx", "agents", "list"])).toBe(true);
    expect(shouldMigrateState(["node", "clawx", "message", "send"])).toBe(true);
  });

  it("reuses command path for migrate state decisions", () => {
    expect(shouldMigrateStateFromPath(["status"])).toBe(false);
    expect(shouldMigrateStateFromPath(["agents", "list"])).toBe(true);
  });
});
