import type { ClawXPluginApi } from "clawx/plugin-sdk";
import { emptyPluginConfigSchema } from "clawx/plugin-sdk";
import { msteamsPlugin } from "./src/channel.js";
import { setMSTeamsRuntime } from "./src/runtime.js";

const plugin = {
  id: "msteams",
  name: "Microsoft Teams",
  description: "Microsoft Teams channel plugin (Bot Framework)",
  configSchema: emptyPluginConfigSchema(),
  register(api: ClawXPluginApi) {
    setMSTeamsRuntime(api.runtime);
    api.registerChannel({ plugin: msteamsPlugin });
  },
};

export default plugin;
