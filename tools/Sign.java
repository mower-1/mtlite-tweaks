import com.android.apksig.ApkSigner;
import com.android.apksig.ApkVerifier;

import java.io.File;
import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Sign {
    public static void main(String[] args) throws Exception {
        // in.apk out.apk keystore storePass alias keyPass
        String in = args[0], out = args[1], ksPath = args[2], ksPass = args[3], alias = args[4], keyPass = args[5];

        KeyStore ks = KeyStore.getInstance("PKCS12");
        try (FileInputStream fis = new FileInputStream(ksPath)) {
            ks.load(fis, ksPass.toCharArray());
        }
        PrivateKey key = (PrivateKey) ks.getKey(alias, keyPass.toCharArray());
        Certificate[] chain = ks.getCertificateChain(alias);
        List<X509Certificate> certs = new ArrayList<>();
        for (Certificate c : chain) {
            certs.add((X509Certificate) c);
        }
        ApkSigner.SignerConfig cfg = new ApkSigner.SignerConfig.Builder("MTLITE", key, certs).build();

        new ApkSigner.Builder(Collections.singletonList(cfg))
                .setInputApk(new File(in))
                .setOutputApk(new File(out))
                .setV1SigningEnabled(true)
                .setV2SigningEnabled(true)
                .setV3SigningEnabled(true)
                .setAlignmentPreserved(true)
                .build()
                .sign();
        System.out.println("签名完成: " + out);

        ApkVerifier.Result r = new ApkVerifier.Builder(new File(out)).build().verify();
        System.out.println("校验通过: " + r.isVerified()
                + "  V1=" + r.isVerifiedUsingV1Scheme()
                + "  V2=" + r.isVerifiedUsingV2Scheme()
                + "  V3=" + r.isVerifiedUsingV3Scheme());
        if (!r.getErrors().isEmpty()) {
            System.out.println("错误: " + r.getErrors());
        }
        if (!r.getWarnings().isEmpty()) {
            System.out.println("警告: " + r.getWarnings());
        }
        System.out.println("签名者: " + r.getSignerCertificates().get(0).getSubjectDN());
    }
}
