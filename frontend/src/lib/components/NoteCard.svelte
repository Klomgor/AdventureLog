<script lang="ts">
	import { t } from 'svelte-i18n';
	import { addToast } from '$lib/toasts';
	import type { Collection, Note, User } from '$lib/types';
	import { createEventDispatcher } from 'svelte';
	const dispatch = createEventDispatcher();

	import Launch from '~icons/mdi/launch';
	import TrashCan from '~icons/mdi/trash-can';
	import Calendar from '~icons/mdi/calendar';
	import DeleteWarning from './DeleteWarning.svelte';

	export let note: Note;
	export let user: User | null = null;
	export let collection: Collection | null = null;

	let isWarningModalOpen: boolean = false;
	let unlinked: boolean = false;

	$: {
		if (collection?.start_date && collection.end_date) {
			const startOutsideRange =
				note.date && collection.start_date < note.date && collection.end_date < note.date;

			const endOutsideRange =
				note.date && collection.start_date > note.date && collection.end_date > note.date;

			unlinked = !!(startOutsideRange || endOutsideRange || !note.date);
		}
	}

	function editNote() {
		dispatch('edit', note);
	}

	async function deleteNote() {
		const res = await fetch(`/api/notes/${note.id}`, {
			method: 'DELETE'
		});
		if (res.ok) {
			addToast('success', $t('notes.note_deleted'));
			isWarningModalOpen = false;
			dispatch('delete', note.id);
		} else {
			addToast($t('notes.note_delete_error'), 'error');
		}
	}
</script>

{#if isWarningModalOpen}
	<DeleteWarning
		title={$t('adventures.delete_note')}
		button_text="Delete"
		description={$t('adventures.note_delete_confirm')}
		is_warning={false}
		on:close={() => (isWarningModalOpen = false)}
		on:confirm={deleteNote}
	/>
{/if}

<div
	class="card w-full max-w-xs sm:max-w-sm md:max-w-md lg:max-w-md xl:max-w-md overflow-hidden bg-neutral text-neutral-content shadow-xl"
>
	<div class="card-body">
		<div class="flex justify-between">
			<h2 class="text-2xl font-semibold -mt-2 break-words text-wrap">
				{note.name}
			</h2>
		</div>
		<div class="badge badge-primary">{$t('adventures.note')}</div>
		{#if unlinked}
			<div class="badge badge-error">{$t('adventures.out_of_range')}</div>
		{/if}
		{#if note.content && note.content.length > 0}
			<p class="line-clamp-6">
				{note.content}
			</p>
		{/if}
		{#if note.links && note.links.length > 0}
			<p>
				{note.links.length}
				{note.links.length > 1 ? $t('adventures.links') : $t('adventures.link')}
			</p>
			<ul class="list-disc pl-6">
				{#each note.links.slice(0, 3) as link}
					<li>
						<a class="link link-primary" href={link}>
							{link.split('//')[1].split('/', 1)[0]}
						</a>
					</li>
				{/each}
				{#if note.links.length > 3}
					<li>…</li>
				{/if}
			</ul>
		{/if}
		{#if note.date && note.date !== ''}
			<div class="inline-flex items-center">
				<Calendar class="w-5 h-5 mr-1" />
				<p>{new Date(note.date).toLocaleDateString(undefined, { timeZone: 'UTC' })}</p>
			</div>
		{/if}
		<div class="card-actions justify-end">
			<!-- <button class="btn btn-neutral mb-2" on:click={() => goto(`/notes/${note.id}`)}
				><Launch class="w-6 h-6" />Open Details</button
			> -->
			<button class="btn btn-neutral-200 mb-2" on:click={editNote}>
				<Launch class="w-6 h-6" />{$t('notes.open')}
			</button>
			{#if note.user_id == user?.uuid || (collection && user && collection.shared_with && collection.shared_with.includes(user.uuid))}
				<button
					id="delete_adventure"
					data-umami-event="Delete Adventure"
					class="btn btn-warning"
					on:click={() => (isWarningModalOpen = true)}><TrashCan class="w-6 h-6" /></button
				>
			{/if}
		</div>
	</div>
</div>
