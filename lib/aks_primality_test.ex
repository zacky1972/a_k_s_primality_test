defmodule AKSPrimalityTest do
  @moduledoc """
  Documentation for `AKSPrimalityTest`.
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
          2..(min(r, n - 1))
          |> Enum.all?(&LehmerGcd.of(n, &1) == 1)
          |> case do
            false -> 
              false

            true -> 
              if n <= r do
                true
              else
                1..(round(:math.sqrt(tortient(r)) * l2n) + 1)
                |> Enum.all?(&is_congruent(&1, n, r))
              end
          end
      end
    end
  end

  @doc false
  @spec order_lower_bound_condition(pos_integer(), pos_integer(), pos_integer()) :: pos_integer() | false
  def order_lower_bound_condition(_, r, upper) when r > upper, do: r

  def order_lower_bound_condition(n, r, upper) do
    cond do
      r < n and LehmerGcd.of(n, r) != 1 -> false
      case multiplicative_order(n, r, 1, rem(n, r)) do
        nil -> order_lower_bound_condition(n, r + 1, upper)
        k when k > upper -> r
      end
      true -> order_lower_bound_condition(n, r + 1, upper)
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

  defp is_congruent(a, n, r) do
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
      1..(min(length(ls1) + length(ls2) - 1, r))
      |> Enum.map(fn i -> {i, 0} end)
      |> Enum.into(%{})

    res =
      for a <- Enum.with_index(ls1), b <- Enum.with_index(ls2) do
        {a, b}
      end
      |> Enum.map(fn {{a, i}, {b, j}} -> {rem(i + j, r), a * b} end)
      |> Enum.reduce(res, fn {index, acc}, res -> Map.put(res, index, Map.get(res, index, 0) + acc) end)

    res
    |> Enum.sort(fn {i1, _}, {i2, _} -> i1 <= i2 end)
    |> Enum.reverse()
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.map(& rem(&1, n))
    |> Enum.reduce([], fn
      0, [] -> []
      v, res -> [v | res]
    end)
  end
end
