// Minimal local KernelSU WebUI bridge. KernelSU Manager provides the global `ksu` object.
export function exec(command, options = {}) {
  return new Promise((resolve, reject) => {
    const name = `meg_exec_${Date.now()}_${Math.random().toString(36).slice(2)}`;
    window[name] = (errno, stdout, stderr) => {
      try { delete window[name]; } catch (_) {}
      resolve({ errno: Number(errno) || 0, stdout: stdout || '', stderr: stderr || '' });
    };
    try {
      if (!window.ksu || typeof window.ksu.exec !== 'function') {
        throw new Error('KernelSU WebUI API tidak tersedia');
      }
      window.ksu.exec(command, JSON.stringify(options), name);
    } catch (e) {
      try { delete window[name]; } catch (_) {}
      reject(e);
    }
  });
}

export function toast(message) {
  try { if (window.ksu && typeof window.ksu.toast === 'function') window.ksu.toast(message); } catch (_) {}
}
