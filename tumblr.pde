import java.io.File;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;

class TumblrClient
{
  public String api_write_url = "http://www.tumblr.com/api/write";
  public String api_generator_name = "impersonal drawing machine";
  
  public String postPhoto(String photoFilename, String caption)
  {
    HttpClient httpclient = new DefaultHttpClient();
    HttpPost httppost = new HttpPost(api_write_url);
    FileBody photoFile = new FileBody(new File(photoFilename));
    MultipartEntity reqEntity = new MultipartEntity();

    try
    {
      reqEntity.addPart("email", new StringBody("lithiumnoid@gmail.com"));
      reqEntity.addPart("password", new StringBody("impersonaldrawings"));
      reqEntity.addPart("type", new StringBody("photo"));
      reqEntity.addPart("data", photoFile);
      reqEntity.addPart("caption", new StringBody(caption));
      reqEntity.addPart("generator", new StringBody(api_generator_name));

      httppost.setEntity(reqEntity);

      //println("executing request " + httppost.getRequestLine());
      HttpResponse response = httpclient.execute(httppost);
      HttpEntity resEntity = response.getEntity();

      info("----------------------------------------");
      info(response.getStatusLine().toString());
      if (resEntity != null) 
      {
          info("Response content length: " + resEntity.getContentLength());
          BufferedReader reader = new BufferedReader(new InputStreamReader(resEntity.getContent()));

          try 
          {
            String result = reader.readLine();
            return result;
          } 
          catch (IOException ex) 
          {
              throw ex;
          } 
          catch (RuntimeException ex) 
          {
              throw ex;
          } 
          finally 
          {
              reader.close();
          }
      }
      if (resEntity != null) {
          resEntity.consumeContent();
      }    
    }
    catch(Exception ex){}
  
    return "-1";
  }
  
}