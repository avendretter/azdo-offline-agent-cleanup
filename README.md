# Azure DevOps Offline Agents Cleanup

A PowerShell script that automatically removes offline agents from specified Azure DevOps agent pools. This tool helps maintain clean and efficient agent pools by removing inactive or disconnected agents.

## Description

In Azure DevOps, build and release agents can sometimes become offline or disconnected due to various reasons such as:
- VM rebuilds
- Network issues
- System updates
- Infrastructure changes

This script automates the cleanup process by:
1. Connecting to specified Azure DevOps agent pools
2. Identifying offline agents
3. Removing them automatically
4. Providing detailed logging of all operations

## Prerequisites

- PowerShell 5.1 or later
- Azure DevOps Personal Access Token (PAT) with the following permissions:
  - Agent Pools (Read & Manage)
- Azure DevOps Organization name

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/azdo-offline-agent-cleanup.git
```

2. Navigate to the repository directory:
```bash
cd azdo-offline-agent-cleanup
```

3. Create a `.env` file in the repository directory with the following variables:
```bash
PAT=your_personal_access_token
ORGANIZATION_NAME=your_organization_name
API_VERSION=5.1
POOLS_LIST=pool1,pool2,pool3
```

## Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| PAT | Azure DevOps Personal Access Token | Yes | - |
| ORGANIZATION_NAME | Your Azure DevOps organization name | Yes | - |
| API_VERSION | Azure DevOps API version | No | 5.1 |
| POOLS_LIST | Comma-separated list of pool names to check | Yes | - |

## Usage

Run the script using PowerShell:
```bash
.\Remove-OfflineAgents.ps1
```
### Example Output
```bash
Checking Pool pool1 for Organization your_organization
Removing: agent1 From Pool: pool1 in Organization: your_organization
Removing: agent2 From Pool: pool1 in Organization: your_organization
No Agents found in pool2 for Organization your_organization
```

## Project Structure

- `Remove-OfflineAgents.ps1` - Main script file
- `.env.template` - Template for environment variables
- `.env` - Your configuration file (not tracked in git)
- `.gitignore` - Git ignore configuration
- `README.md` - Project documentation
- `.devcontainer/` - Development container configuration for VS Code

## Development Container

This project includes a Dev Container configuration for Visual Studio Code, which provides a consistent development environment with all necessary tools pre-installed.

### Prerequisites for Dev Container
- Docker Desktop
- Visual Studio Code
- VS Code Remote - Containers extension

### Using the Dev Container

1. Open the project in VS Code
2. When prompted, click "Reopen in Container"
   - Or use the command palette (F1) and select "Remote-Containers: Reopen in Container"
3. VS Code will build and start the container with:
   - PowerShell 7
   - Required PowerShell modules
   - Git
   - Common development tools

### Benefits of Using Dev Container
- Consistent development environment across team members
- All required tools and dependencies pre-installed
- Isolated environment that doesn't affect your local system
- Easy onboarding for new contributors

## Security Considerations

1. Environment File Security:
   - Never commit the `.env` file to version control
   - Keep your PAT secure and rotate it regularly
   - Use minimum required permissions for the PAT

2. Best Practices:
   - Store the `.env` file securely
   - Regularly update the PAT
   - Review agent removals in Azure DevOps audit logs

## Error Handling

The script includes comprehensive error handling for:
- Invalid credentials
- Network connectivity issues
- Missing or invalid pool names
- API request failures
- Environment file configuration issues

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Support

For support, please open an issue in the GitHub repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Azure DevOps REST API Documentation
- PowerShell Community

