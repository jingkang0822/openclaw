import path from "node:path";
import { afterEach, describe, expect, it, vi } from "vitest";
import { resolveStorePath } from "./paths.js";

describe("resolveStorePath", () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("uses CLAWX_HOME for tilde expansion", () => {
    vi.stubEnv("CLAWX_HOME", "/srv/clawx-home");
    vi.stubEnv("HOME", "/home/other");

    const resolved = resolveStorePath("~/.clawx/agents/{agentId}/sessions/sessions.json", {
      agentId: "research",
    });

    expect(resolved).toBe(
      path.resolve("/srv/clawx-home/.clawx/agents/research/sessions/sessions.json"),
    );
  });
});
