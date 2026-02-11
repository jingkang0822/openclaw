import type { ClawXPluginApi } from "clawx/plugin-sdk";
import { emptyPluginConfigSchema } from "clawx/plugin-sdk";
import { signalPlugin } from "./src/channel.js";
import { setSignalRuntime } from "./src/runtime.js";

const plugin = {
  id: "signal",
  name: "Signal",
  description: "Signal channel plugin",
  configSchema: emptyPluginConfigSchema(),
  register(api: ClawXPluginApi) {
    setSignalRuntime(api.runtime);
    api.registerChannel({ plugin: signalPlugin });
  },
};

export default plugin;
