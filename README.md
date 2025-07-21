# AKS Primality Test

[![Hex.pm](https://img.shields.io/hexpm/v/a_k_s_primality_test)](https://hex.pm/packages/a_k_s_primality_test)
[![Hex.pm](https://img.shields.io/hexpm/dt/a_k_s_primality_test)](https://hex.pm/packages/a_k_s_primality_test)
[![Hex.pm](https://img.shields.io/hexpm/l/a_k_s_primality_test)](https://hex.pm/packages/a_k_s_primality_test)

A pure Elixir implementation of the AKS (Agrawal-Kayal-Saxena) primality test algorithm.

## Overview

The AKS primality test is a deterministic polynomial-time algorithm for determining whether a given number is prime. It was the first polynomial-time primality test that is both general and deterministic, proving that the primality problem is in P.

## Features

- **Deterministic**: Always gives the correct answer (no probabilistic uncertainty)
- **Polynomial Time**: Runs in $O((\log n)^{12})$ time
- **Pure Elixir**: No external dependencies for the core algorithm
- **Well Documented**: Comprehensive documentation with mathematical explanations
- **Type Safe**: Full type specifications for all functions

## Installation

The package can be installed by adding `a_k_s_primality_test` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:a_k_s_primality_test, "~> 1.0"}
  ]
end
```

## Usage

### Basic Usage

```elixir
iex> AKSPrimalityTest.of(2)
true

iex> AKSPrimalityTest.of(3)
true

iex> AKSPrimalityTest.of(4)
false

iex> AKSPrimalityTest.of(17)
true

iex> AKSPrimalityTest.of(25)
false
```

### Testing Larger Numbers

```elixir
# Test some known primes
iex> AKSPrimalityTest.of(97)
true

iex> AKSPrimalityTest.of(101)
true

# Test some composite numbers
iex> AKSPrimalityTest.of(100)
false

iex> AKSPrimalityTest.of(121)
false

iex> AKSPrimalityTest.of(127)
true

iex> AKSPrimalityTest.of(128)
false

iex> AKSPrimalityTest.of(8191)
true
```

## Algorithm Overview

The AKS algorithm works in the following steps:

1. **Perfect Power Test**: Check if $n$ is a perfect power ($n = a^b$ for some $a > 1$, $b > 1$)
2. **Order Finding**: Find the smallest $r$ such that the order of $n$ modulo $r$ is greater than $\log^2(n)$
3. **GCD Test**: Check that $n$ is coprime with all numbers up to $r$
4. **Polynomial Test**: Verify that $(X + a)^n \equiv X^n + a \pmod{X^r - 1, n}$ for certain values of $a$

## Mathematical Foundation

The AKS algorithm is based on the following theorem:

> Let $n \geq 2$ be an integer. If $n$ is prime, then for all $a$ coprime to $n$,
> $(X + a)^n \equiv X^n + a \pmod{n}$.

The algorithm finds a suitable parameter $r$ and tests this congruence modulo $X^r - 1$.

## Time Complexity

The algorithm runs in $O((\log n)^{12})$ time, making it polynomial but not practical for very large numbers compared to probabilistic tests like Miller-Rabin. However, it is theoretically important as it proves that primality testing is in P.

## Dependencies

This implementation depends on the following modules:
- `PerfectPower` - for perfect power detection
- `LehmerGcd` - for GCD calculations  
- `PrimeFactorization` - for prime factorization

## Documentation

- [API Documentation](https://hexdocs.pm/a_k_s_primality_test) - Full API reference
- [Mathematical Background](https://hexdocs.pm/a_k_s_primality_test/AKSPrimalityTest.html) - Detailed algorithm explanation

## Performance Considerations

While the AKS algorithm is theoretically polynomial-time, it is not designed for practical use with very large numbers. For production applications requiring primality testing, consider:

- **Miller-Rabin** - Probabilistic but very fast
- **AKS** - Deterministic but slower (this implementation)
- **Specialized libraries** - For very large numbers

## License

Copyright (c) 2025 University of Kitakyushu

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## References

- Agrawal, M., Kayal, N., & Saxena, N. (2004). PRIMES is in P. *Annals of Mathematics*, 781-793.
- [AKS Primality Test on Wikipedia](https://en.wikipedia.org/wiki/AKS_primality_test)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

