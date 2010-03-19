void debug(String message)
{
  writeLog(message, "debug");
}

void info(String message)
{
  writeLog(message, "info");
}

void error(String message)
{
  writeLog(message, "debug");
}

void writeLog(String message, String severity)
{
  println(millis() + " [" + severity + "] " + message);
}