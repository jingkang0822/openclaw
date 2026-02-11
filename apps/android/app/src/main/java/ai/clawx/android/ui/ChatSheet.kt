package ai.clawx.android.ui

import androidx.compose.runtime.Composable
import ai.clawx.android.MainViewModel
import ai.clawx.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
