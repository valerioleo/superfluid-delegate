import hre from 'hardhat'
import { getNamedAccount } from '../helpers/accounts'
import { ERC721Token } from '../typechain-types'
import { getParams, DeployParams } from '../constants/erc721'

const { deployments, ethers } = hre

const { deploy } = deployments

type DeployOptions = {
  deployParams?: DeployParams,
  forceRedeploy?: Boolean,
  deploymentName?: string
}
export const deployERC721Token = async (options: DeployOptions = {}): Promise<ERC721Token> => {
  const deployParams = await getParams(options.deployParams)
  const deploymentName = options.deploymentName || 'ERC721Token'

  await deploy(deploymentName, {
    from: await getNamedAccount('deployer'),
    contract: 'ERC721Token',
    args: [
      deployParams.name,
      deployParams.symbol,
      deployParams.baseTokenURI
    ],
    skipIfAlreadyDeployed: false,
    log: true,
    ...options
  })

  const erc721Instance = await ethers.getContract(deploymentName) as ERC721Token

  return erc721Instance
}

const deployScript = async () => {
  await deployERC721Token()
}

deployScript.tags = ['ERC721Token']
export default deployScript
