# Generated by Django 5.0.8 on 2024-08-11 12:59

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('adventures', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='adventure',
            old_name='id',
            new_name='temp_id',
        ),
        migrations.RenameField(
            model_name='checklist',
            old_name='id',
            new_name='temp_id',
        ),
        migrations.RenameField(
            model_name='checklistitem',
            old_name='id',
            new_name='temp_id',
        ),
        migrations.RenameField(
            model_name='collection',
            old_name='id',
            new_name='temp_id',
        ),
        migrations.RenameField(
            model_name='note',
            old_name='id',
            new_name='temp_id',
        ),
        migrations.RenameField(
            model_name='transportation',
            old_name='id',
            new_name='temp_id',
        ),
    ]
