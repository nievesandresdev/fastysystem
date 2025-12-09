/**
 * Script para obtener el HWID del sistema actual
 */

const crypto = require('crypto');
const os = require('os');
const { execSync } = require('child_process');

function getHardwareId() {
  try {
    const cpuInfo = os.cpus()[0]?.model || 'unknown';
    const totalMem = os.totalmem();
    const hostname = os.hostname();
    
    let diskSerial = 'unknown';
    try {
      if (process.platform === 'win32') {
        const wmicOutput = execSync('wmic diskdrive get serialnumber', { encoding: 'utf-8' });
        const serials = wmicOutput.split('\n').filter(line => line.trim() && !line.includes('SerialNumber'));
        if (serials.length > 0) {
          diskSerial = serials[0].trim();
        }
      } else {
        diskSerial = execSync('lsblk -o serial -n 2>/dev/null || echo unknown', { encoding: 'utf-8' }).trim();
      }
    } catch {
      diskSerial = os.hostname();
    }

    const networkInterfaces = os.networkInterfaces();
    let macAddress = 'unknown';
    for (const interfaceName in networkInterfaces) {
      const interfaces = networkInterfaces[interfaceName];
      if (interfaces) {
        for (const iface of interfaces) {
          if (!iface.internal && iface.mac !== '00:00:00:00:00:00') {
            macAddress = iface.mac;
            break;
          }
        }
        if (macAddress !== 'unknown') break;
      }
    }

    const hwidString = `${cpuInfo}-${totalMem}-${hostname}-${diskSerial}-${macAddress}`;
    const hwid = crypto.createHash('sha256').update(hwidString).digest('hex');
    return hwid.substring(0, 32).toUpperCase();
  } catch (error) {
    console.error('Error obteniendo HWID:', error);
    return crypto.createHash('sha256').update(os.hostname()).digest('hex').substring(0, 32).toUpperCase();
  }
}

const hwid = getHardwareId();

console.log('\n========================================');
console.log('  HARDWARE ID (HWID) DEL SISTEMA');
console.log('========================================\n');
console.log('HWID:', hwid);
console.log('\nUsa este HWID para generar una licencia:');
console.log('  node scripts/generate-license.js', hwid, '[dias]\n');

