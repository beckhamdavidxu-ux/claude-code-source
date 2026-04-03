import { z } from 'zod'

// SandboxManager stub - static class-like object
export const SandboxManager = {
  isSupportedPlatform() { return false },
  checkDependencies() { return { errors: [], warnings: [] } },
  async initialize(_config, callback) { if (callback) await callback() },
  updateConfig(_config) {},
  async reset() {},
  async wrapWithSandbox(_config, fn) { return fn() },
  getFsReadConfig() { return null },
  getFsWriteConfig() { return null },
  getNetworkRestrictionConfig() { return null },
  getIgnoreViolations() { return null },
  annotateStderrWithSandboxFailures(_command, stderr) { return stderr },
  cleanupAfterCommand() {},
  getProxyPort() { return null },
  getSocksProxyPort() { return null },
  getLinuxHttpSocketPath() { return null },
  getLinuxSocksSocketPath() { return null },
  async waitForNetworkInitialization() {},
  getSandboxViolationStore() { return new SandboxViolationStore() },
}

export const SandboxRuntimeConfigSchema = z.object({}).passthrough()

export class SandboxViolationStore {
  add() {}
  getAll() { return [] }
  clear() {}
}
