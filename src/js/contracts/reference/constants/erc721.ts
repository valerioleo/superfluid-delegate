// defaults
export const name = 'Name';
export const symbol = 'SMBL';
export const baseTokenURI = '';

export type DeployParams = {
  name?: string;
  symbol?: string;
  baseTokenURI?: string;
}
export const getParams = async (params: DeployParams = {}) => ({
  name,
  symbol,
  baseTokenURI,
  ...params
});
