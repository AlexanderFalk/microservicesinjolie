import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class Main {
    public static void main(String[] args ) {
        try {

            SimpleDateFormat sdf = new SimpleDateFormat("EEE, MMM d yyyy HH:mm:ss a z", Locale.ENGLISH);
            
            final Date dt = sdf.parse( "Sun, Jul 07 2019 01:43:31 AM PDT" );
            System.out.println(dt.getTime());
            
        }catch(ParseException e) {
            System.out.println(e);
        }
        
    }
}

