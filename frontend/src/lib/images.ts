import { api } from '$lib/api';
import type { Upload } from '$lib/types';

export type UploadPurpose = 'photo' | 'project' | 'album' | 'background' | 'note';

export const MAX_SIZES = {
	avatar: 512,
	album: 640,
	project: 1600,
	photo: 1920,
	note: 1920,
	background: 2560
};

async function toBlob(canvas: HTMLCanvasElement, type: string, quality?: number) {
	return new Promise<Blob | null>((resolve) => canvas.toBlob(resolve, type, quality));
}

export async function prepareImage(file: File, maxSize: number) {
	if (!file.type.startsWith('image/')) throw new Error('not an image');

	const bitmap = await createImageBitmap(file, { imageOrientation: 'from-image' });
	const { width: originalWidth, height: originalHeight } = bitmap;

	if (file.type === 'image/gif' && file.size < 4 * 1024 * 1024) {
		bitmap.close();
		return { blob: file as Blob, name: 'image.gif', width: originalWidth, height: originalHeight };
	}

	const scale = Math.min(1, maxSize / Math.max(originalWidth, originalHeight));
	const width = Math.max(1, Math.round(originalWidth * scale));
	const height = Math.max(1, Math.round(originalHeight * scale));
	const canvas = document.createElement('canvas');
	canvas.width = width;
	canvas.height = height;
	canvas.getContext('2d')!.drawImage(bitmap, 0, 0, width, height);
	bitmap.close();

	let blob = await toBlob(canvas, 'image/webp', 0.86);
	let name = 'image.webp';
	if (!blob || blob.type !== 'image/webp') {
		const transparent = file.type === 'image/png';
		blob = await toBlob(canvas, transparent ? 'image/png' : 'image/jpeg', 0.88);
		name = transparent ? 'image.png' : 'image.jpg';
	}
	if (!blob) throw new Error('encode failed');
	return { blob, name, width, height };
}

export async function uploadImage(file: File, purpose: UploadPurpose) {
	const image = await prepareImage(file, MAX_SIZES[purpose]);
	const form = new FormData();
	form.set('file', image.blob, image.name);
	form.set('purpose', purpose);
	form.set('width', String(image.width));
	form.set('height', String(image.height));
	const { upload } = await api.post<{ upload: Upload }>('/api/my/uploads', form);
	return upload;
}

export async function imageForm(file: File, maxSize: number) {
	const image = await prepareImage(file, maxSize);
	const form = new FormData();
	form.set('file', image.blob, image.name);
	return form;
}
