import { ClientEnv } from "./env.client";
import { ServerEnv } from "./env.server";

export const env: ClientEnv | ServerEnv =
  typeof window === "undefined"
    ? require("./env.server").env
    : require("./env.client").env;

export type Env = typeof env;
