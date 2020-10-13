from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase
from django.urls import resolve, reverse

from .views import upload


class MediaUploadTests(TestCase):
    def test_upload_view_status_code(self):
        url = reverse('upload')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)

    def test_upload_url_resolves_upload_view(self):
        view = resolve('/')
        self.assertEqual(view.func, upload)

    def test_upload_file(self):
        url = reverse('upload')
        image = SimpleUploadedFile('file.jpg', b'file_content', content_type='multipart/form-data')
        response = self.client.post(url, {'uploaded_file': image})
        
        self.assertEqual(response.status_code, 200)
        self.assertIn('file_url', response.context)
        self.assertContains(response, 'File uploaded at:')
