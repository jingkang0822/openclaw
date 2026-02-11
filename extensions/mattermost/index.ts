import type { ClawXPluginApi } from "clawx/plugin-sdk";
import { emptyPluginConfigSchema } from "clawx/plugin-sdk";
import { mattermostPlugin } from "./src/channel.js";
import { setMattermostRuntime } from "./src/runtime.js";

const plugin = {
  id: "mattermost",
  name: "Mattermost",
  description: "Mattermost channel plugin",
  configSchema: emptyPluginConfigSchema(),
  register(api: ClawXPluginApi) {
    setMattermostRuntime(api.runtime);
    api.registerChannel({ plugin: mattermostPlugin });
  },
};

export default plugin;
