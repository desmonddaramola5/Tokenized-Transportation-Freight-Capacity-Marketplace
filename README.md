# Tokenized Transportation Freight Capacity Marketplace

A decentralized marketplace for freight transportation built on the Stacks blockchain using Clarity smart contracts. This platform connects shippers with verified carriers, enabling efficient capacity matching, rate negotiation, and performance tracking.

## Overview

The marketplace consists of five interconnected smart contracts that manage the entire freight transportation lifecycle:

1. **Carrier Verification Contract** - Validates and manages freight carrier registrations
2. **Capacity Listing Contract** - Lists available freight capacity from carriers
3. **Shipment Matching Contract** - Matches shipment requests with available capacity
4. **Rate Negotiation Contract** - Facilitates rate negotiations between parties
5. **Performance Rating Contract** - Tracks and manages performance ratings

## Features

### For Carriers
- Register and get verified on the platform
- List available freight capacity with details
- Receive and respond to shipment requests
- Negotiate rates with shippers
- Build reputation through performance ratings

### For Shippers
- Create shipment requests with specific requirements
- Browse available capacity listings
- Negotiate rates with carriers
- Rate carrier performance after delivery
- Access carrier performance history

### Platform Benefits
- **Transparency**: All transactions and ratings are recorded on-chain
- **Trust**: Carrier verification and performance tracking system
- **Efficiency**: Automated matching of shipments with capacity
- **Fair Pricing**: Competitive rate negotiation system
- **Accountability**: Immutable performance records

## Smart Contract Architecture

### Carrier Verification Contract (\`carrier-verification.clar\`)
- Manages carrier registration and verification process
- Stores carrier documents and credentials
- Handles carrier status (pending, verified, suspended)
- Only contract owner can verify carriers

### Capacity Listing Contract (\`capacity-listing.clar\`)
- Allows verified carriers to list available capacity
- Stores route, capacity, dates, and pricing information
- Manages capacity status (available, reserved, booked)
- Enables capacity search and filtering

### Shipment Matching Contract (\`shipment-matching.clar\`)
- Handles shipment requests from shippers
- Creates matches between requests and capacity
- Manages match lifecycle (pending, accepted, completed)
- Tracks agreed rates and terms

### Rate Negotiation Contract (\`rate-negotiation.clar\`)
- Facilitates rate negotiations between parties
- Maintains negotiation history and offers
- Handles counter-offers and final agreements
- Includes expiration mechanisms

### Performance Rating Contract (\`performance-rating.clar\`)
- Collects ratings from both shippers and carriers
- Calculates average ratings and statistics
- Tracks on-time delivery performance
- Maintains detailed review history

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd freight-marketplace
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks testnet:

\`\`\`bash
# Deploy carrier verification contract first
clarinet deploy --testnet contracts/carrier-verification.clar

# Deploy other contracts
clarinet deploy --testnet contracts/capacity-listing.clar
clarinet deploy --testnet contracts/shipment-matching.clar
clarinet deploy --testnet contracts/rate-negotiation.clar
clarinet deploy --testnet contracts/performance-rating.clar
\`\`\`

## Usage Examples

### Carrier Registration
\`\`\`clarity
(contract-call? .carrier-verification register-carrier "ABC Trucking" "DOT123456")
\`\`\`

### Creating Capacity Listing
\`\`\`clarity
(contract-call? .capacity-listing create-capacity-listing
"New York, NY"
"Los Angeles, CA"
u40000
u2000
u1640995200
u1641081600
u250)
\`\`\`

### Creating Shipment Request
\`\`\`clarity
(contract-call? .shipment-matching create-shipment-request
"Chicago, IL"
"Miami, FL"
u25000
u1500
u1640995200
u1641081600
u300)
\`\`\`

## Testing

The project includes comprehensive tests using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment and initialization
- Carrier registration and verification
- Capacity listing creation and management
- Shipment matching functionality
- Rate negotiation workflows
- Performance rating system

## Security Considerations

- All contracts include proper authorization checks
- Input validation prevents invalid data entry
- Status checks prevent unauthorized state changes
- Rate limits and expiration mechanisms prevent abuse
- Immutable records ensure data integrity

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or support, please open an issue in the GitHub repository.
\`\`\`

## Roadmap

- [ ] Integration with external logistics APIs
- [ ] Mobile application development
- [ ] Advanced analytics and reporting
- [ ] Multi-modal transportation support
- [ ] Insurance integration
- [ ] Payment automation with escrow
  \`\`\`
