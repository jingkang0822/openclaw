import type { ClawXPluginApi } from "clawx/plugin-sdk";
import { emptyPluginConfigSchema } from "clawx/plugin-sdk";
import { matrixPlugin } from "./src/channel.js";
import { setMatrixRuntime } from "./src/runtime.js";

const plugin = {
  id: "matrix",
  name: "Matrix",
  description: "Matrix channel plugin (matrix-js-sdk)",
  configSchema: emptyPluginConfigSchema(),
  register(api: ClawXPluginApi) {
    setMatrixRuntime(api.runtime);
    api.registerChannel({ plugin: matrixPlugin });
  },
};

export default plugin;
