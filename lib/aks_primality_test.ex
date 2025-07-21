defmodule AKSPrimalityTest do
  @moduledoc """
  Implementation of the AKS (Agrawal-Kayal-Saxena) primality test algorithm.

  The AKS primality test is a deterministic polynomial-time algorithm for determining
  whether a given number is prime. It was the first polynomial-time primality test
  that is both general and deterministic.

  ## Algorithm Overview

  The AKS algorithm works in the following steps:

  1. **Perfect Power Test**: Check if n is a perfect power ($a^b$ for some $a > 1$, $b > 1$)
  2. **Order Finding**: Find the smallest r such that the order of n modulo r is greater than $\\log_2 n$
  3. **GCD Test**: Check that n is coprime with all numbers up to r
  4. **Polynomial Test**: Verify that $(X + a)^n \\equiv X^n + a (\\pmod X^r - 1, n)$ for certain values of a

  ## Time Complexity

  The algorithm runs in $O((\\log n)^{12})$ time, making it polynomial but not practical
  for large numbers compared to probabilistic tests like Miller-Rabin.

  ## Examples

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

      iex> AKSPrimalityTest.of(127)
      true

      iex> AKSPrimalityTest.of(128)
      false

      iex> AKSPrimalityTest.of(8191)
      true

  ## Dependencies

  This implementation depends on the following modules:
  - `PerfectPower` - for perfect power detection
  - `LehmerGcd` - for GCD calculations
  - `PrimeFactorization` - for prime factorization

  ## References

  - Agrawal, M., Kayal, N., & Saxena, N. (2004). PRIMES is in P.
    Annals of Mathematics, 781-793.
  """

  @doc """
  Determines whether a given positive integer is prime using the AKS primality test.

  ## Parameters

  - `n` - A positive integer to test for primality

  ## Returns

  - `true` if n is prime
  - `false` if n is composite

  ## Examples

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

  ## Algorithm Steps

  1. **Special case**: 2 is always prime
  2. **Perfect power test**: If n is a perfect power, it's composite
  3. **Order finding**: Find suitable parameter r for polynomial test
  4. **GCD verification**: Ensure n is coprime with numbers up to r
  5. **Polynomial congruence**: Final verification using polynomial arithmetic
  """
  @spec of(pos_integer()) :: boolean()
  def of(2), do: true

  def of(n) do
    if PerfectPower.exponential_form?(n) do
      false
    else
      l2n = :math.log2(n)
      cl2n = ceil(l2n)
      upper = cl2n * cl2n

      case order_lower_bound_condition(n, 2, upper) do
        false ->
          false

        r ->
          2..min(r, n - 1)
          |> Enum.all?(&(LehmerGcd.of(n, &1) == 1))
          |> epilogue(n, r, l2n)
      end
    end
  end

  defp epilogue(false, _, _, _), do: false
  defp epilogue(true, n, r, _) when n <= r, do: true

  defp epilogue(true, n, r, l2n) do
    1..(round(:math.sqrt(tortient(r)) * l2n) + 1)
    |> Enum.all?(&congruent?(&1, n, r))
  end

  @doc false
  @spec order_lower_bound_condition(pos_integer(), pos_integer(), pos_integer()) ::
          pos_integer() | false
  def order_lower_bound_condition(_, r, upper) when r > upper, do: r

  def order_lower_bound_condition(n, r, upper) do
    if r < n and LehmerGcd.of(n, r) != 1 do
      false
    else
      case multiplicative_order(n, r, 1, rem(n, r)) do
        nil -> order_lower_bound_condition(n, r + 1, upper)
        k when k > upper -> r
        _ -> order_lower_bound_condition(n, r + 1, upper)
      end
    end
  end

  defp multiplicative_order(_n, _r, k, 1), do: k
  defp multiplicative_order(_n, r, k, _x) when k > r, do: nil

  defp multiplicative_order(n, r, k, x) do
    multiplicative_order(n, r, k + 1, rem(x * n, r))
  end

  defp tortient(r) do
    PrimeFactorization.of(r)
    |> Enum.uniq()
    |> Enum.reduce(r, fn p, res ->
      res * (p - 1) / p
    end)
  end

  defp congruent?(a, n, r) do
    i = rem(n, r)
    an = rem(a, n)

    pow([a, 1], n, r)
    |> Enum.with_index()
    |> Enum.map(fn
      {v, 0} -> v == an
      {v, ^i} -> v == 1
      {v, _} -> v == 0
    end)
    |> Enum.all?()
  end

  defp pow(ls, n, r) do
    pow_s(ls, n, r, n)
  end

  defp pow_s(ls, _, _, 1), do: ls

  defp pow_s(ls, n, r, m) when Bitwise.band(m, 1) == 0 do
    pls = pow_s(ls, n, r, Bitwise.bsr(m, 1))
    product(n, r, pls, pls)
  end

  defp pow_s(ls, n, r, m) do
    ls1 = pow_s(ls, n, r, m - 1)
    ls2 = pow_s(ls, n, r, 1)
    product(n, r, ls1, ls2)
  end

  defp product(n, r, ls1, ls2) do
    res =
      1..min(length(ls1) + length(ls2) - 1, r)
      |> Enum.map(fn _ -> 0 end)
      |> List.to_tuple()

    for a <- Enum.with_index(ls1), b <- Enum.with_index(ls2) do
      {a, b}
    end
    |> Enum.map(fn {{a, i}, {b, j}} -> {rem(i + j, r), a * b} end)
    |> Enum.reduce(res, fn {index, acc}, res ->
      put_elem(res, index, elem(res, index) + acc)
    end)
    |> Tuple.to_list()
    |> Enum.reverse()
    |> Enum.map(&rem(&1, n))
    |> Enum.reduce([], fn
      0, [] -> []
      v, res -> [v | res]
    end)
  end
end
