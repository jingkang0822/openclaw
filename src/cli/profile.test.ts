import path from "node:path";
import { describe, expect, it } from "vitest";
import { formatCliCommand } from "./command-format.js";
import { applyCliProfileEnv, parseCliProfileArgs } from "./profile.js";

describe("parseCliProfileArgs", () => {
  it("leaves gateway --dev for subcommands", () => {
    const res = parseCliProfileArgs(["node", "clawx", "gateway", "--dev", "--allow-unconfigured"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBeNull();
    expect(res.argv).toEqual(["node", "clawx", "gateway", "--dev", "--allow-unconfigured"]);
  });

  it("still accepts global --dev before subcommand", () => {
    const res = parseCliProfileArgs(["node", "clawx", "--dev", "gateway"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("dev");
    expect(res.argv).toEqual(["node", "clawx", "gateway"]);
  });

  it("parses --profile value and strips it", () => {
    const res = parseCliProfileArgs(["node", "clawx", "--profile", "work", "status"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("work");
    expect(res.argv).toEqual(["node", "clawx", "status"]);
  });

  it("rejects missing profile value", () => {
    const res = parseCliProfileArgs(["node", "clawx", "--profile"]);
    expect(res.ok).toBe(false);
  });

  it("rejects combining --dev with --profile (dev first)", () => {
    const res = parseCliProfileArgs(["node", "clawx", "--dev", "--profile", "work", "status"]);
    expect(res.ok).toBe(false);
  });

  it("rejects combining --dev with --profile (profile first)", () => {
    const res = parseCliProfileArgs(["node", "clawx", "--profile", "work", "--dev", "status"]);
    expect(res.ok).toBe(false);
  });
});

describe("applyCliProfileEnv", () => {
  it("fills env defaults for dev profile", () => {
    const env: Record<string, string | undefined> = {};
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    const expectedStateDir = path.join("/home/peter", ".clawx-dev");
    expect(env.CLAWX_PROFILE).toBe("dev");
    expect(env.CLAWX_STATE_DIR).toBe(expectedStateDir);
    expect(env.CLAWX_CONFIG_PATH).toBe(path.join(expectedStateDir, "clawx.json"));
    expect(env.CLAWX_GATEWAY_PORT).toBe("19001");
  });

  it("does not override explicit env values", () => {
    const env: Record<string, string | undefined> = {
      CLAWX_STATE_DIR: "/custom",
      CLAWX_GATEWAY_PORT: "19099",
    };
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    expect(env.CLAWX_STATE_DIR).toBe("/custom");
    expect(env.CLAWX_GATEWAY_PORT).toBe("19099");
    expect(env.CLAWX_CONFIG_PATH).toBe(path.join("/custom", "clawx.json"));
  });
});

describe("formatCliCommand", () => {
  it("returns command unchanged when no profile is set", () => {
    expect(formatCliCommand("clawx doctor --fix", {})).toBe("clawx doctor --fix");
  });

  it("returns command unchanged when profile is default", () => {
    expect(formatCliCommand("clawx doctor --fix", { CLAWX_PROFILE: "default" })).toBe(
      "clawx doctor --fix",
    );
  });

  it("returns command unchanged when profile is Default (case-insensitive)", () => {
    expect(formatCliCommand("clawx doctor --fix", { CLAWX_PROFILE: "Default" })).toBe(
      "clawx doctor --fix",
    );
  });

  it("returns command unchanged when profile is invalid", () => {
    expect(formatCliCommand("clawx doctor --fix", { CLAWX_PROFILE: "bad profile" })).toBe(
      "clawx doctor --fix",
    );
  });

  it("returns command unchanged when --profile is already present", () => {
    expect(formatCliCommand("clawx --profile work doctor --fix", { CLAWX_PROFILE: "work" })).toBe(
      "clawx --profile work doctor --fix",
    );
  });

  it("returns command unchanged when --dev is already present", () => {
    expect(formatCliCommand("clawx --dev doctor", { CLAWX_PROFILE: "dev" })).toBe(
      "clawx --dev doctor",
    );
  });

  it("inserts --profile flag when profile is set", () => {
    expect(formatCliCommand("clawx doctor --fix", { CLAWX_PROFILE: "work" })).toBe(
      "clawx --profile work doctor --fix",
    );
  });

  it("trims whitespace from profile", () => {
    expect(formatCliCommand("clawx doctor --fix", { CLAWX_PROFILE: "  jbclawx  " })).toBe(
      "clawx --profile jbclawx doctor --fix",
    );
  });

  it("handles command with no args after clawx", () => {
    expect(formatCliCommand("clawx", { CLAWX_PROFILE: "test" })).toBe("clawx --profile test");
  });

  it("handles pnpm wrapper", () => {
    expect(formatCliCommand("pnpm clawx doctor", { CLAWX_PROFILE: "work" })).toBe(
      "pnpm clawx --profile work doctor",
    );
  });
});
