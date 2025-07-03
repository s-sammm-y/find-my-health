import QRCode from 'qrcode';

const user_id = '74'; 

QRCode.toFile('user_qr.png', user_id, {
  color: {
    dark: '#000',  
    light: '#FFF'  
  }
}, function (err) {
  if (err) throw err;
  console.log('QR code saved as user_qr.png');
});
