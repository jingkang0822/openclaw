package ai.clawx.android.protocol

import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
import org.junit.Assert.assertEquals
import org.junit.Test

class ClawXCanvasA2UIActionTest {
  @Test
  fun extractActionNameAcceptsNameOrAction() {
    val nameObj = Json.parseToJsonElement("{\"name\":\"Hello\"}").jsonObject
    assertEquals("Hello", ClawXCanvasA2UIAction.extractActionName(nameObj))

    val actionObj = Json.parseToJsonElement("{\"action\":\"Wave\"}").jsonObject
    assertEquals("Wave", ClawXCanvasA2UIAction.extractActionName(actionObj))

    val fallbackObj =
      Json.parseToJsonElement("{\"name\":\"  \",\"action\":\"Fallback\"}").jsonObject
    assertEquals("Fallback", ClawXCanvasA2UIAction.extractActionName(fallbackObj))
  }

  @Test
  fun formatAgentMessageMatchesSharedSpec() {
    val msg =
      ClawXCanvasA2UIAction.formatAgentMessage(
        actionName = "Get Weather",
        sessionKey = "main",
        surfaceId = "main",
        sourceComponentId = "btnWeather",
        host = "Peter’s iPad",
        instanceId = "ipad16,6",
        contextJson = "{\"city\":\"Vienna\"}",
      )

    assertEquals(
      "CANVAS_A2UI action=Get_Weather session=main surface=main component=btnWeather host=Peter_s_iPad instance=ipad16_6 ctx={\"city\":\"Vienna\"} default=update_canvas",
      msg,
    )
  }

  @Test
  fun jsDispatchA2uiStatusIsStable() {
    val js = ClawXCanvasA2UIAction.jsDispatchA2UIActionStatus(actionId = "a1", ok = true, error = null)
    assertEquals(
      "window.dispatchEvent(new CustomEvent('clawx:a2ui-action-status', { detail: { id: \"a1\", ok: true, error: \"\" } }));",
      js,
    )
  }
}
