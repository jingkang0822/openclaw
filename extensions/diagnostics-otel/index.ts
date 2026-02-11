import type { ClawXPluginApi } from "clawx/plugin-sdk";
import { emptyPluginConfigSchema } from "clawx/plugin-sdk";
import { createDiagnosticsOtelService } from "./src/service.js";

const plugin = {
  id: "diagnostics-otel",
  name: "Diagnostics OpenTelemetry",
  description: "Export diagnostics events to OpenTelemetry",
  configSchema: emptyPluginConfigSchema(),
  register(api: ClawXPluginApi) {
    api.registerService(createDiagnosticsOtelService());
  },
};

export default plugin;
