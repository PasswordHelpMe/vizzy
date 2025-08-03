# Contributing to Vizio TV API

Thank you for your interest in contributing to the Vizio TV API! This document provides guidelines for contributing to this project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/vizio-api.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes
6. Commit your changes: `git commit -m "Add your feature"`
7. Push to your fork: `git push origin feature/your-feature-name`
8. Create a Pull Request

## Development Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
pip install pytest pytest-asyncio flake8
```

2. Copy the environment file:
```bash
cp env.example .env
```

3. Update `.env` with your TV's details

4. Run the API:
```bash
python main.py
```

5. Test the API:
```bash
python test_api.py
```

## Code Style

- Follow PEP 8 style guidelines
- Use meaningful variable and function names
- Add docstrings to functions and classes
- Keep functions small and focused

## Testing

- Run the test suite: `python test_api.py`
- Ensure all tests pass before submitting a PR
- Add tests for new features

## Pull Request Guidelines

- Provide a clear description of the changes
- Include any relevant issue numbers
- Ensure the code follows the project's style guidelines
- Test your changes thoroughly
- Update documentation if needed

## Issues

When creating an issue, please include:

- A clear description of the problem
- Steps to reproduce the issue
- Expected vs actual behavior
- Your environment details (OS, Python version, etc.)
- Any error messages or logs

## License

By contributing to this project, you agree that your contributions will be licensed under the MIT License. 