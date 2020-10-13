from django.shortcuts import render
from django.core.files.storage import FileSystemStorage


def upload(request):
    if request.method == 'POST' and request.FILES['uploaded_file']:
        uploaded_file = request.FILES['uploaded_file']
        fs = FileSystemStorage()
        filename = fs.save(uploaded_file.name, uploaded_file)
        file_url = fs.url(filename)
        return render(request, 'upload.html', {
            'file_url': file_url,
        })
    return render(request, 'upload.html')
