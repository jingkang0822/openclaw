import type { ClawXPluginApi } from "../../src/plugins/types.js";
import { createLlmTaskTool } from "./src/llm-task-tool.js";

export default function register(api: ClawXPluginApi) {
  api.registerTool(createLlmTaskTool(api), { optional: true });
}
