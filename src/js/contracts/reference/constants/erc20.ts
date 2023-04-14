import {toWei} from '../helpers/utils';
import {getNamedAccount} from '../helpers/accounts';

// defaults
export const name = 'wETH';
export const symbol = 'wETH';
export const maxSupply = toWei(999_999_999);

export type DeployParams = {
  name?: string;
  symbol?: string;
  maxSupply?: string;
  treasury?: string;
}
export const getParams = async (params: DeployParams = {}) => ({
  name,
  symbol,
  maxSupply,
  treasury: await getNamedAccount('deployer'),
  ...params
});
