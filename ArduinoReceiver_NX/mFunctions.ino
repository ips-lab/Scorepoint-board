void DispFill(char pat) {
  for (int i = 0; i < g_LmxDev1.NbPanel; i++) {
    LedMxSetRam(&g_LmxDev1, 0, pat, 32, g_LmxDev1.PanelAddr[i]);
    LedMxSetRam(&g_LmxDev2, 0, pat, 32, g_LmxDev2.PanelAddr[i]);
  }
}

// Scroll text from right to left until text runs off the display
void DispScroll(char *pText) {
  int col = g_LmxDev1.NbPanel * 32;
  int i = col;
  int pixlen;

  pixlen = LedMxPixStrLen(&g_LmxDev1, pText);

  for (i = col; i + pixlen > 0; i -= 1) {
    LedMxPrintAt(&g_LmxDev1, i, pText);
    LedMxPrintAt(&g_LmxDev2, i, pText);      
    delay(35);
  }
}

void loadNames(){
  char tempName1[G.nameP1.length()+1];
  G.nameP1.toCharArray(tempName1, G.nameP1.length()+1);

  char tempName2[G.nameP2.length()+1];
  G.nameP2.toCharArray(tempName2, G.nameP2.length()+1);

  LedMxPrintLeft(&g_LmxDev1, tempName1);
  LedMxPrintLeft(&g_LmxDev2, tempName2);
}

