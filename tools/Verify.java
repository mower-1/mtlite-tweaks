import com.android.apksig.ApkVerifier;
import java.io.File;
public class Verify {
    public static void main(String[] a) throws Exception {
        ApkVerifier.Result r = new ApkVerifier.Builder(new File(a[0])).build().verify();
        System.out.println("verified=" + r.isVerified() + " V1=" + r.isVerifiedUsingV1Scheme()
            + " V2=" + r.isVerifiedUsingV2Scheme() + " V3=" + r.isVerifiedUsingV3Scheme());
        System.out.println("errors=" + r.getErrors());
        System.out.println("warnings=" + r.getWarnings());
        if (!r.getSignerCertificates().isEmpty())
            System.out.println("cert=" + r.getSignerCertificates().get(0).getSubjectDN());
    }
}
