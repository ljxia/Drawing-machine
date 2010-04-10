import javax.mail.*;
import javax.mail.internet.*;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Auth extends Authenticator {

  public Auth() {
    super();
  }

  public PasswordAuthentication getPasswordAuthentication() {
    String username, password;
    username = "lithiumnoid@gmail.com";
    password = "impersonal";
    debug("authenticating... ");
    return new PasswordAuthentication(username, password);
  }
}

void sendMail(String filename) {
  // Create a session
  String host="smtp.gmail.com";
  Properties props=new Properties();

  // SMTP Session
  props.put("mail.transport.protocol", "smtp");
  props.put("mail.smtp.host", host);
  props.put("mail.smtp.port", "587");
  props.put("mail.smtp.auth", "true");
  // We need TTLS, which gmail requires
  props.put("mail.smtp.starttls.enable","true");

  // Create a session
  Session session = Session.getDefaultInstance(props, new Auth());

  try
  {
    MimeMessage msg=new MimeMessage(session);
    msg.setFrom(new InternetAddress("lithiumnoid@gmail.com", "lithium"));
    msg.addRecipient(Message.RecipientType.TO,new InternetAddress("430prudev@tumblr.com"));
    msg.setSubject("");
    BodyPart messageBodyPart = new MimeBodyPart();
 // Fill the message
    messageBodyPart.setText("Sent from impersonal");
    Multipart multipart = new MimeMultipart();
    multipart.addBodyPart(messageBodyPart);
   // Part two is attachment
    messageBodyPart = new MimeBodyPart();
    DataSource source = new FileDataSource(filename);
    messageBodyPart.setDataHandler(new DataHandler(source));
    
    
    SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd-HHmmss");
    
    messageBodyPart.setFileName(df.format(new Date()) + ".png");
    multipart.addBodyPart(messageBodyPart);
    msg.setContent(multipart);
    msg.setSentDate(new Date());
    Transport.send(msg);
    debug("Mail sent!");
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }

}