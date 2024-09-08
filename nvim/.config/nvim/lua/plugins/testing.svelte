<script>
  const condition = true
  const asyncCondition = async () => false
  const items = ['a', 'b', 'c']
</script>

{#await asyncVal()}{:then val}{:catch e}{/await}
