import { useState } from "react";
import QrReader from "react-qr-reader2";

function QRScanner() {
  const [result, setResult] = useState("No result");
  const handleScan = (data) => {
    if (data) {
      setResult(data);
      console.log("Scanned QR:", data);
    }
  };

  const handleError = (err) => {
    console.error("QR Error:", err);
  };

  return (
    <div style={{ paddingTop: "60px", textAlign: "center" }}>
      <h2>QR Code Scanner</h2>

      <div style={{ maxWidth: "500px", margin: "auto" }}>
        <QrReader
          delay={300}
          onError={handleError}
          onScan={handleScan}
          style={{ width: "100%" }}
        />
      </div>

      <p><strong>Result:</strong> {result}</p>
    </div>
  );
}

export default QRScanner;