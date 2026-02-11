import path from "node:path";
import { describe, expect, it } from "vitest";
import { resolveGatewayStateDir } from "./paths.js";

describe("resolveGatewayStateDir", () => {
  it("uses the default state dir when no overrides are set", () => {
    const env = { HOME: "/Users/test" };
    expect(resolveGatewayStateDir(env)).toBe(path.join("/Users/test", ".clawx"));
  });

  it("appends the profile suffix when set", () => {
    const env = { HOME: "/Users/test", CLAWX_PROFILE: "rescue" };
    expect(resolveGatewayStateDir(env)).toBe(path.join("/Users/test", ".clawx-rescue"));
  });

  it("treats default profiles as the base state dir", () => {
    const env = { HOME: "/Users/test", CLAWX_PROFILE: "Default" };
    expect(resolveGatewayStateDir(env)).toBe(path.join("/Users/test", ".clawx"));
  });

  it("uses CLAWX_STATE_DIR when provided", () => {
    const env = { HOME: "/Users/test", CLAWX_STATE_DIR: "/var/lib/clawx" };
    expect(resolveGatewayStateDir(env)).toBe(path.resolve("/var/lib/clawx"));
  });

  it("expands ~ in CLAWX_STATE_DIR", () => {
    const env = { HOME: "/Users/test", CLAWX_STATE_DIR: "~/clawx-state" };
    expect(resolveGatewayStateDir(env)).toBe(path.resolve("/Users/test/clawx-state"));
  });

  it("preserves Windows absolute paths without HOME", () => {
    const env = { CLAWX_STATE_DIR: "C:\\State\\clawx" };
    expect(resolveGatewayStateDir(env)).toBe("C:\\State\\clawx");
  });
});
