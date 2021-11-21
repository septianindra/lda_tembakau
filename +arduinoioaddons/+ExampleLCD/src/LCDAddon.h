#include "LibraryBase.h"
#include "LiquidCrystal.h"

const char MSG_pLCD_CREATE_LCD_SHIELD[]       PROGMEM = "Arduino::pLCD = new LiquidCrystal(%d, %d, %d, %d, %d, %d);\n";
const char MSG_pLCD_INITIALIZE_LCD_SHIELD[]   PROGMEM = "Arduino::pLCD->begin(%d, %d);\n";
const char MSG_pLCD_CLEAR_LCD_SHIELD[]        PROGMEM = "Arduino::pLCD->clear();\n";
const char MSG_pLCD_PRINT[]                   PROGMEM = "Arduino::pLCD->print(%s);\n";
const char MSG_SET_CURSOR_LCD_SHIELD[]        PROGMEM = "Arduino::pLCD->setCursor(%d, %d);\n";
const char MSG_pLCD_DELETE_LCD_SHIELD[]       PROGMEM = "Arduino::delete pLCD;\n";
