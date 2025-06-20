<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import TrashCanOutline from '~icons/mdi/trash-can-outline';
	import FileDocumentEdit from '~icons/mdi/file-document-edit';
	import type { Collection, Transportation, User } from '$lib/types';
	import { addToast } from '$lib/toasts';
	import { t } from 'svelte-i18n';
	import DeleteWarning from './DeleteWarning.svelte';
	// import ArrowDownThick from '~icons/mdi/arrow-down-thick';
	import { TRANSPORTATION_TYPES_ICONS } from '$lib';
	import { formatAllDayDate, formatDateInTimezone } from '$lib/dateUtils';
	import { isAllDay } from '$lib';

	function getTransportationIcon(type: string) {
		if (type in TRANSPORTATION_TYPES_ICONS) {
			return TRANSPORTATION_TYPES_ICONS[type as keyof typeof TRANSPORTATION_TYPES_ICONS];
		} else {
			return '🚗';
		}
	}
	const dispatch = createEventDispatcher();

	export let transportation: Transportation;
	export let user: User | null = null;
	export let collection: Collection | null = null;

	const toMiles = (km: any) => (Number(km) * 0.621371).toFixed(1);

	let isWarningModalOpen: boolean = false;

	function editTransportation() {
		dispatch('edit', transportation);
	}

	let unlinked: boolean = false;

	$: {
		if (collection?.start_date && collection.end_date) {
			// Parse transportation dates
			let transportationStartDate = transportation.date
				? new Date(transportation.date.split('T')[0]) // Ensure proper date parsing
				: null;
			let transportationEndDate = transportation.end_date
				? new Date(transportation.end_date.split('T')[0])
				: null;

			// Parse collection dates
			let collectionStartDate = new Date(collection.start_date);
			let collectionEndDate = new Date(collection.end_date);

			// // Debugging outputs
			// console.log(
			// 	'Transportation Start Date:',
			// 	transportationStartDate,
			// 	'Transportation End Date:',
			// 	transportationEndDate
			// );
			// console.log(
			// 	'Collection Start Date:',
			// 	collectionStartDate,
			// 	'Collection End Date:',
			// 	collectionEndDate
			// );

			// Check if the collection range is outside the transportation range
			const startOutsideRange =
				transportationStartDate &&
				collectionStartDate < transportationStartDate &&
				collectionEndDate < transportationStartDate;

			const endOutsideRange =
				transportationEndDate &&
				collectionStartDate > transportationEndDate &&
				collectionEndDate > transportationEndDate;

			unlinked = !!(
				startOutsideRange ||
				endOutsideRange ||
				(!transportationStartDate && !transportationEndDate)
			);
		}
	}

	async function deleteTransportation() {
		let res = await fetch(`/api/transportations/${transportation.id}`, {
			method: 'DELETE',
			headers: {
				'Content-Type': 'application/json'
			}
		});
		if (!res.ok) {
			console.log($t('transportation.transportation_delete_error'));
		} else {
			addToast('info', $t('transportation.transportation_deleted'));
			isWarningModalOpen = false;
			dispatch('delete', transportation.id);
		}
	}
</script>

{#if isWarningModalOpen}
	<DeleteWarning
		title={$t('adventures.delete_transportation')}
		button_text="Delete"
		description={$t('adventures.transportation_delete_confirm')}
		is_warning={false}
		on:close={() => (isWarningModalOpen = false)}
		on:confirm={deleteTransportation}
	/>
{/if}

<div
	class="card w-full max-w-md bg-base-300 text-base-content shadow-2xl hover:shadow-3xl transition-all duration-300 border border-base-300 hover:border-primary/20 group"
>
	<div class="card-body p-6 space-y-6">
		<!-- Header -->
		<div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
			<h2 class="text-xl font-bold truncate">{transportation.name}</h2>
			<div class="flex flex-wrap gap-2">
				<div class="badge badge-secondary">
					{$t(`transportation.modes.${transportation.type}`)}
					{getTransportationIcon(transportation.type)}
				</div>
				{#if transportation.type === 'plane' && transportation.flight_number}
					<div class="badge badge-neutral">{transportation.flight_number}</div>
				{/if}
				{#if unlinked}
					<div class="badge badge-error">{$t('adventures.out_of_range')}</div>
				{/if}
			</div>
		</div>

		<!-- Route Info -->
		<div class="space-y-3">
			{#if transportation.from_location}
				<div class="flex gap-2 text-sm">
					<span class="font-medium whitespace-nowrap">{$t('adventures.from')}:</span>
					<span class="break-words">{transportation.from_location}</span>
				</div>
			{/if}

			{#if transportation.to_location}
				<div class="flex gap-2 text-sm">
					<span class="font-medium whitespace-nowrap">{$t('adventures.to')}:</span>
					<span class="break-words">{transportation.to_location}</span>
				</div>
			{/if}

			{#if transportation.distance && !isNaN(+transportation.distance)}
				<div class="flex gap-2 text-sm">
					<span class="font-medium whitespace-nowrap">{$t('adventures.distance')}:</span>
					<span>
						{(+transportation.distance).toFixed(1)} km / {toMiles(transportation.distance)} mi
					</span>
				</div>
			{/if}
		</div>

		<!-- Time Info -->
		<div class="space-y-3">
			{#if transportation.date}
				<div class="flex gap-2 text-sm">
					<span class="font-medium whitespace-nowrap">{$t('adventures.start')}:</span>
					<span>
						{#if isAllDay(transportation.date) && (!transportation.end_date || isAllDay(transportation.end_date))}
							{formatAllDayDate(transportation.date)}
						{:else}
							{formatDateInTimezone(transportation.date, transportation.start_timezone)}
							{#if transportation.start_timezone}
								<span class="ml-1 text-xs opacity-60">({transportation.start_timezone})</span>
							{/if}
						{/if}
					</span>
				</div>
			{/if}

			{#if transportation.end_date}
				<div class="flex gap-2 text-sm">
					<span class="font-medium whitespace-nowrap">{$t('adventures.end')}:</span>
					<span>
						{#if isAllDay(transportation.end_date) && (!transportation.date || isAllDay(transportation.date))}
							{formatAllDayDate(transportation.end_date)}
						{:else}
							{formatDateInTimezone(transportation.end_date, transportation.end_timezone)}
							{#if transportation.end_timezone}
								<span class="ml-1 text-xs opacity-60">({transportation.end_timezone})</span>
							{/if}
						{/if}
					</span>
				</div>
			{/if}
		</div>

		<!-- Actions -->
		{#if transportation.user_id === user?.uuid || (collection && user && collection.shared_with?.includes(user.uuid))}
			<div class="pt-4 border-t border-base-300 flex justify-end gap-2">
				<button
					class="btn btn-neutral btn-sm flex items-center gap-1"
					on:click={editTransportation}
					title={$t('transportation.edit')}
				>
					<FileDocumentEdit class="w-5 h-5" />
					<span>{$t('transportation.edit')}</span>
				</button>
				<button
					class="btn btn-secondary btn-sm flex items-center gap-1"
					on:click={() => (isWarningModalOpen = true)}
					title={$t('adventures.delete')}
				>
					<TrashCanOutline class="w-5 h-5" />
					<span>{$t('adventures.delete')}</span>
				</button>
			</div>
		{/if}
	</div>
</div>
