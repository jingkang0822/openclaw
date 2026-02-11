package ai.clawx.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class ClawXProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", ClawXCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", ClawXCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", ClawXCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", ClawXCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", ClawXCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", ClawXCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", ClawXCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", ClawXCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", ClawXCapability.Canvas.rawValue)
    assertEquals("camera", ClawXCapability.Camera.rawValue)
    assertEquals("screen", ClawXCapability.Screen.rawValue)
    assertEquals("voiceWake", ClawXCapability.VoiceWake.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", ClawXScreenCommand.Record.rawValue)
  }
}
