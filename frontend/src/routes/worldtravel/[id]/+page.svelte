<script lang="ts">
	import RegionCard from '$lib/components/RegionCard.svelte';
	import type { Region, VisitedRegion } from '$lib/types';
	import { MapLibre, Marker } from 'svelte-maplibre';
	import type { PageData } from './$types';
	import { addToast } from '$lib/toasts';
	import { t } from 'svelte-i18n';
	export let data: PageData;

	let regions: Region[] = data.props?.regions || [];
	let visitedRegions: VisitedRegion[] = data.props?.visitedRegions || [];

	let filteredRegions: Region[] = [];

	let searchQuery: string = '';

	$: {
		if (searchQuery === '') {
			filteredRegions = regions;
		} else {
			// always filter from the original regions list
			filteredRegions = regions.filter((region) =>
				region.name.toLowerCase().includes(searchQuery.toLowerCase())
			);
		}
	}

	const country = data.props?.country || null;
	console.log(data);

	let showGeo: boolean = true;

	function togleVisited(region: Region) {
		return () => {
			const visitedRegion = visitedRegions.find(
				(visitedRegion) => visitedRegion.region === region.id
			);
			if (visitedRegion) {
				visitedRegions = visitedRegions.filter(
					(visitedRegion) => visitedRegion.region !== region.id
				);
				removeVisit(region);
			} else {
				markVisited(region);
			}
		};
	}

	async function markVisited(region: Region) {
		let res = await fetch(`/api/visitedregion/`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ region: region.id })
		});
		if (!res.ok) {
			console.error('Failed to mark region as visited');
			addToast('error', `${$t('worldtravel.failed_to_mark_visit')} ${region.name}`);
			return;
		} else {
			visitedRegions = [...visitedRegions, await res.json()];
			addToast(
				'success',
				`${$t('worldtravel.visit_to')} ${region.name} ${$t('worldtravel.marked_visited')}`
			);
		}
	}
	async function removeVisit(region: Region) {
		let res = await fetch(`/api/visitedregion/${region.id}`, {
			headers: { 'Content-Type': 'application/json' },
			method: 'DELETE'
		});
		if (!res.ok) {
			console.error($t('worldtravel.region_failed_visited'));
			addToast('error', `${$t('worldtravel.failed_to_mark_visit')} ${region.name}`);
			return;
		} else {
			visitedRegions = visitedRegions.filter((visitedRegion) => visitedRegion.region !== region.id);
			addToast('info', `${$t('worldtravel.visit_to')} ${region.name} ${$t('worldtravel.removed')}`);
		}
	}

	let numRegions: number = country?.num_regions || 0;
	let numVisitedRegions: number = country?.num_visits || 0;

	visitedRegions = visitedRegions.filter(
		(visitedRegion, index, self) =>
			index === self.findIndex((t) => t.region === visitedRegion.region)
	);
</script>

<h1 class="text-center font-bold text-4xl mb-4">{$t('worldtravel.regions_in')} {country?.name}</h1>
<div class="flex items-center justify-center mb-4">
	<div class="stats shadow bg-base-300">
		<div class="stat">
			<div class="stat-title">{$t('worldtravel.region_stats')}</div>
			<div class="stat-value">{numVisitedRegions}/{numRegions} {$t('adventures.visited')}</div>
			{#if numRegions === numVisitedRegions}
				<div class="stat-desc">{$t('worldtravel.all_visited')} {country?.name} 🎉!</div>
			{:else}
				<div class="stat-desc">{$t('adventures.keep_exploring')}</div>
			{/if}
		</div>
	</div>
</div>

<div class="flex items-center justify-center mb-4">
	<input
		type="text"
		placeholder={$t('navbar.search')}
		class="input input-bordered w-full max-w-xs"
		bind:value={searchQuery}
	/>
	{#if searchQuery.length > 0}
		<!-- clear button -->
		<div class="flex items-center justify-center ml-4">
			<button class="btn btn-neutral" on:click={() => (searchQuery = '')}>
				{$t('worldtravel.clear_search')}
			</button>
		</div>
	{/if}
</div>

<div class="flex flex-wrap gap-4 mr-4 ml-4 justify-center content-center">
	{#each filteredRegions as region}
		<RegionCard
			{region}
			visited={visitedRegions.some((visitedRegion) => visitedRegion.region === region.id)}
			on:visit={(e) => {
				visitedRegions = [...visitedRegions, e.detail];
				numVisitedRegions++;
			}}
			on:remove={() => {
				visitedRegions = visitedRegions.filter(
					(visitedRegion) => visitedRegion.region !== region.id
				);
				numVisitedRegions--;
			}}
		/>
	{/each}
</div>

<div class="flex justify-center border-neutral p-4 rounded-lg border-4 max-w-lg m-auto mt-4">
	<label for="show-geo">{$t('adventures.show_region_labels')}</label>
	<input
		type="checkbox"
		id="show-geo"
		name="show-geo"
		class="checkbox ml-2"
		bind:checked={showGeo}
		on:click={() => (showGeo = !showGeo)}
	/>
</div>

<div class="mt-4 mb-4 flex justify-center">
	<!-- checkbox to toggle marker -->

	<MapLibre
		style="https://basemaps.cartocdn.com/gl/voyager-gl-style/style.json"
		class="aspect-[9/16] max-h-[70vh] sm:aspect-video sm:max-h-full w-10/12 rounded-lg"
		standardControls
		center={[regions[0]?.longitude || 0, regions[0]?.latitude || 0]}
		zoom={2}
	>
		<!-- MapEvents gives you access to map events even from other components inside the map,
  where you might not have access to the top-level `MapLibre` component. In this case
  it would also work to just use on:click on the MapLibre component itself. -->
		<!-- <MapEvents on:click={addMarker} /> -->

		{#each regions as region}
			{#if region.latitude && region.longitude && showGeo}
				<Marker
					lngLat={[region.longitude, region.latitude]}
					class="grid px-2 py-1 place-items-center rounded-full border border-gray-200 {visitedRegions.some(
						(visitedRegion) => visitedRegion.region === region.id
					)
						? 'bg-green-200'
						: 'bg-red-200'} text-black focus:outline-6 focus:outline-black"
					on:click={togleVisited(region)}
				>
					<span class="text-xs">
						{region.name}
					</span>
				</Marker>
			{/if}
		{/each}
	</MapLibre>
</div>

<svelte:head>
	<title
		>{data.props && data.props.country ? `Regions in ${data.props.country.name}` : 'Regions'}</title
	>
	<meta
		name="description"
		content="View the regions in countries and mark them visited to track your world travel."
	/>
</svelte:head>
