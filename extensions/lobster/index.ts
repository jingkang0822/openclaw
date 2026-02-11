import type {
  AnyAgentTool,
  ClawXPluginApi,
  ClawXPluginToolFactory,
} from "../../src/plugins/types.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default function register(api: ClawXPluginApi) {
  api.registerTool(
    ((ctx) => {
      if (ctx.sandboxed) {
        return null;
      }
      return createLobsterTool(api) as AnyAgentTool;
    }) as ClawXPluginToolFactory,
    { optional: true },
  );
}
