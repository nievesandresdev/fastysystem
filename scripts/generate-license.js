/**
 * Script para generar licencias (solo para el desarrollador)
 * Uso: node scripts/generate-license.js <HWID> [dias]
 */

const crypto = require('crypto');
const os = require('os');
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Clave secreta (debe ser la misma que en backend/src/utils/license.ts)
const SECRET_KEY = process.env.LICENSE_SECRET_KEY || 'FASTY_SYSTEM_SECRET_KEY_2024_CHANGE_IN_PRODUCTION';

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

function generateLicense(hwid, expirationDays = 365) {
  const expirationDate = new Date();
  expirationDate.setDate(expirationDate.getDate() + expirationDays);
  
  const licenseData = {
    hwid,
    expiresAt: expirationDate.toISOString(),
    issuedAt: new Date().toISOString(),
  };

  const dataString = JSON.stringify(licenseData);
  const signature = crypto.createHmac('sha256', SECRET_KEY).update(dataString).digest('hex');
  
  const license = {
    ...licenseData,
    signature,
  };

  return Buffer.from(JSON.stringify(license)).toString('base64');
}

// Obtener argumentos
const args = process.argv.slice(2);
const hwid = args[0];
const days = parseInt(args[1]) || 365;

if (!hwid) {
  console.log('========================================');
  console.log('  GENERADOR DE LICENCIAS - FASTY SYSTEM');
  console.log('========================================\n');
  console.log('Uso: node scripts/generate-license.js <HWID> [dias]');
  console.log('\nEjemplo:');
  console.log('  node scripts/generate-license.js ABC123... 365');
  console.log('\nPara obtener el HWID del sistema actual:');
  console.log('  node scripts/get-hwid.js');
  process.exit(1);
}

const license = generateLicense(hwid, days);
const expirationDate = new Date();
expirationDate.setDate(expirationDate.getDate() + days);

console.log('\n========================================');
console.log('  LICENCIA GENERADA');
console.log('========================================\n');
console.log('HWID:', hwid);
console.log('Días de validez:', days);
console.log('Fecha de expiración:', expirationDate.toLocaleDateString('es-ES'));
console.log('\nClave de licencia:');
console.log('----------------------------------------');
console.log(license);
console.log('----------------------------------------\n');
console.log('Guarda esta clave de licencia de forma segura.');
console.log('El cliente debe usar esta clave para activar el sistema.\n');

