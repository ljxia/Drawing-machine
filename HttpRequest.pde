import java.net.HttpURLConnection;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;


class HttpRequest
{
  private String defaultContentEncoding;

  HttpRequest()
  {
    this.defaultContentEncoding = Charset.defaultCharset().name();
  }

  public String send( String urlString, String method, Hashtable parameters, Hashtable properties) throws IOException 
  {
    HttpURLConnection urlConnection = null;
    Enumeration enumerator = null;
    if (method.equalsIgnoreCase("GET") && parameters != null) 
    {
      //println("composing url");
      
      StringBuffer param = new StringBuffer();
      int i = 0;
      enumerator = parameters.keys();
      while (enumerator.hasMoreElements()) 
      {
        String key = enumerator.nextElement().toString();
        if (i == 0)
        param.append("?");
        else
        param.append("&");
        param.append(key).append("=").append(parameters.get(key).toString());
        i++;
      }
      urlString += param;
    }
    
    //println("complete url: " + urlString);
    
    URL url = new URL(urlString);
    urlConnection = (HttpURLConnection) url.openConnection();

    urlConnection.setRequestMethod(method);
    urlConnection.setDoOutput(true);
    urlConnection.setDoInput(true);
    urlConnection.setUseCaches(false);
    
    //println("set property");

    if (properties != null)
    {
      enumerator = properties.keys();
      while (enumerator.hasMoreElements()) 
      {
        String key = enumerator.nextElement().toString();
        urlConnection.addRequestProperty(key, properties.get(key).toString());
      }      
    }

    //println("set param");

    if (method.equalsIgnoreCase("POST") && parameters != null) 
    {
      StringBuffer param = new StringBuffer();
      enumerator = parameters.keys();
      int i = 0;
      while (enumerator.hasMoreElements()) 
      {
        String key = enumerator.nextElement().toString();
        if (i>0) param.append("&");
        param.append(key).append("=").append(parameters.get(key).toString());
        i++;
      }
      
      //println(param.toString());
      
      urlConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
      urlConnection.setRequestProperty("Content-Length", "" + Integer.toString(param.toString().getBytes().length));
      
      DataOutputStream wr = new DataOutputStream (urlConnection.getOutputStream ());
      
      wr.write(param.toString().getBytes());
      wr.flush();
      wr.close();
    }
    
    //println("send request");
    //println("---------------");
    return this.getContent(urlString, urlConnection);
  }

  private String getContent(String urlString, HttpURLConnection urlConnection) throws IOException 
  {
    try 
    {
      //println(urlConnection.getRequestMethod());
      
      InputStream in = urlConnection.getInputStream();
      BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(in));
      StringBuffer temp = new StringBuffer();
      String line = bufferedReader.readLine();
      while (line != null) 
      {
        temp.append(line).append("\r\n");
        line = bufferedReader.readLine();
      }
      bufferedReader.close();

      String encoding = urlConnection.getContentEncoding();
      if (encoding == null)
      encoding = this.defaultContentEncoding;

      return new String(temp.toString().getBytes(), encoding);
    } 
    catch (IOException e) 
    {
      throw e;
    } 
    finally 
    {
      if (urlConnection != null)
      urlConnection.disconnect();
    }
  }

}