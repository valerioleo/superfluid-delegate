import hre from 'hardhat'
import { getNamedAccount } from '../helpers/accounts'
import { ERC20Token } from '../typechain-types'
import { getParams, DeployParams } from '../constants/erc20'

const { deployments, ethers } = hre

const { deploy } = deployments

type DeployOptions = {
  deployParams?: DeployParams;
  deploymentName?: string
}
export const deployErc20Token = async (options: DeployOptions = {}): Promise<ERC20Token> => {
  const deployParams = await getParams(options.deployParams);
  const deploymentName = options.deploymentName || 'ERC20Token';

  await deploy(deploymentName, {
    from: await getNamedAccount('deployer'),
    contract: 'ERC20Token',
    args: [
      deployParams.name,
      deployParams.symbol,
      deployParams.maxSupply,
      deployParams.treasury
    ],
    log: true,
    ...options
  })

  const erc20Instance = await ethers.getContract(deploymentName) as ERC20Token

  return erc20Instance
}

const deployScript = async () => {
  await deployErc20Token()
}

deployScript.tags = ['ERC20Token']
export default deployScript
