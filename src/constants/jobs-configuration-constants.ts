import path from 'node:path'
import ms from 'ms'
import { REGISTER_TEMP_PROFILE_IMAGES_PATH } from './file-constants'

export const JOBS_TIMEZONE = 'America/Sao_Paulo'
export const TEMP_FILES_DIRECTORY_ABSOLUTE_PATH = path.resolve(REGISTER_TEMP_PROFILE_IMAGES_PATH)
export const ERASE_FILES_CONCURRENCY = 10
export const TEMP_PROFILE_IMAGES_TTL_IN_MS = ms('1d')
