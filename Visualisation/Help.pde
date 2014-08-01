/** @file Help.pde
 * @author Jan Drabek, Martin Ukrop
 * @brief helper object which contains all text about help and credits
 */
 
class Help {
  
  void draw() {
    background(brownMedium);
    textFont(fonts[2]);
    fill(brownDark);
    text("Nápověda", 80, 80);
    text("Zásluhy", 600, 80);
    
    textFont(fonts[0]);
    String text = "";
    text +="Ročníky\n";
    text += "    p\n";
    text += "    n\n";
    text += "Kategorie\n";
    text += "    1\n";
    text += "    2\n";
    text += "    3\n";
    text += "Týmy\n";
    text += "     home\n";
    text += "     end\n";
    text += "     page up\n";
    text += "     page down\n";
    text += "     levé/pravé tlačítko\n";
    text += "Animace\n";
    text += "    mezerník/enter\n";
    text += "    šipka vlevo/vpravo\n";
    text += "    šipka dolů/nahoru\n";
    text += "    s\n";
    text += "    f\n";
    text += "    e\n";
    text += "Nápověda\n";
    text += "    h\n";
    text(text, 80, 150);
    text = "";
    text +="\n";
    text += "předchozí ročník\n";
    text += "následující ročník\n";
    text += "\n";
    text += "zahrnout/schovat vysokoškoláky\n";
    text += "zahrnout/schovat středoškoláky\n";
    text += "zahrnout/shocvat ostatní\n";
    text += "Týmy\n";
    text += "posun na začátek\n";
    text += "posun na konec\n";
    text += "posun na předchozí stránku\n";
    text += "posun na další stránku\n";
    text += "zobrazí detail týmu\n";
    text += "\n";
    text += "přehrání/pauza\n";
    text += "skok na začátek/konec\n";
    text += "skok na předchozí/následující minutu\n";
    text += "snížit rychlost\n";
    text += "zvýšit rychlost\n";
    text += "skončit na konci\n";
    text += "\n";
    text += "otevřít/zavřít\n";
    text(text, 270, 150);
    
    text = "";
    text += "Autoři\n";
    text += "   - Martin Ukrop\n";
    text += "   - Jan Drábek\n\n";
    text += "Webová stránka soutěže\n";
    text += "    interlos.fi.muni.cz\n\n";
    text += "Tento projekt by nevzniknul nebýt předmětu\n";
    text += "PA055 Vizualizace komplexních dat vyučovaného\n";
    text += "na Masarykově univerzitě. Vyučujícímu předmětu,\n";
    text += "Mateji Lexovi, tímto děkujeme za tuto příležitost.\n\n";
    text += "Taktéž chceme poděkovat všem organizátorům soutěže\n";
    text += "InterSoB i soutěžícím, bez kterých nemohla být tato\n";
    text += "vizualizace taková jaká je.";
    
    text(text, 600, 150);
    
    stroke(brownLight);
    fill(brownMedium);
    rect(screenWidth-210, screenHeight-60, 180, 30);
    fill(brownDark);
    textFont(fonts[1]);
    text("zavřít", screenWidth-145, screenHeight-52+textAscent());
  }
}
