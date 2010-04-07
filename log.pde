PrintWriter logFile;

void initLog()
{
  try
  {
    logFile = new PrintWriter(Config.LOG_FILE);
  }
  catch(FileNotFoundException e)
  {
    logFile = createWriter(Config.LOG_FILE);
  }
}

void destroyLog()
{
  logFile.flush();
  logFile.close();
}

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
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  String timestamp = df.format(new Date());
  
  println(timestamp + " [" + severity + "] " + message);
  logFile.write(timestamp + " [" + severity + "] " + message + "\r\n");
  logFile.flush();
}